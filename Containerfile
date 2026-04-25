# Stage 1: compile ext-grpc and ext-protobuf
FROM dhi.io/php:8-alpine3.22-dev AS ext-build
RUN apk add --no-cache gcc make g++ autoconf linux-headers zlib-dev
RUN pecl install grpc protobuf

# Stage 2: install composer dependencies
FROM dhi.io/composer:2-alpine3.22-dev AS composer-build
WORKDIR /app
COPY composer.json .
RUN composer install --no-dev --optimize-autoloader

# Runtime
FROM dhi.io/php:8-alpine3.22-fpm
WORKDIR /app
# Copy compiled extensions
COPY --from=ext-build /opt/php-8.5/lib/php/extensions/no-debug-non-zts-20250925/grpc.so \
     /opt/php-8.5/lib/php/extensions/no-debug-non-zts-20250925/grpc.so
COPY --from=ext-build /opt/php-8.5/lib/php/extensions/no-debug-non-zts-20250925/protobuf.so \
     /opt/php-8.5/lib/php/extensions/no-debug-non-zts-20250925/protobuf.so
# Enable extensions
RUN echo "extension=grpc.so" >> /opt/php-8.5/etc/php/php.ini \
 && echo "extension=protobuf.so" >> /opt/php-8.5/etc/php/php.ini
# Copy app
COPY --from=composer-build /app/vendor vendor/
COPY gen/ gen/
COPY demo_server.php .
EXPOSE 50051
CMD ["php", "demo_server.php"]
