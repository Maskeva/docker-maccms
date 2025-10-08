# 使用最新PHP-FPM官方镜像
FROM php:8.5.0RC1-fpm

# 设置工作目录
WORKDIR /var/www/html

# 安装系统依赖和PHP扩展
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    libzip-dev \
    libwebp-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install zip gd pdo_mysql \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 从GitHub下载苹果CMS10最新版
RUN wget -O maccms10.zip https://github.com/magicblack/maccms10/archive/refs/heads/master.zip \
    && unzip maccms10.zip \
    && mv maccms10-master/* . \
    && mv maccms10-master/.* . 2>/dev/null || true \
    && rm -rf maccms10-master maccms10.zip

# 设置权限
RUN chmod -R 755 /var/www/html \
    && chown -R www-data:www-data /var/www/html

# 创建数据目录并设置可写权限
RUN mkdir -p /var/www/html/datas \
    && chmod -R 777 /var/www/html/datas

# 暴露端口
EXPOSE 9000

CMD ["php-fpm"]