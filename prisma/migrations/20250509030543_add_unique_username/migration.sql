-- CreateTable
CREATE TABLE `applicationletter` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `toEmail` VARCHAR(191) NOT NULL,
    `category_letter` ENUM('SuratPengantarKTP', 'SuratKeteranganDomisili', 'SuratKeteranganUsaha', 'SuratPengantarNikah', 'SuratKeteranganTidakMampu') NOT NULL,
    `data_nik` VARCHAR(191) NOT NULL,
    `create_by` INTEGER NOT NULL,
    `create_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `ApplicationLetter_id_key`(`id`),
    INDEX `ApplicationLetter_create_by_fkey`(`create_by`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `cashflow` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NOT NULL,
    `date` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `category` ENUM('Kredit', 'Debit') NOT NULL,
    `amount` INTEGER NOT NULL,
    `create_by` INTEGER NOT NULL,
    `create_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `update_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `CashFlow_id_key`(`id`),
    INDEX `CashFlow_create_by_fkey`(`create_by`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `citizen` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `full_name` VARCHAR(191) NOT NULL,
    `dob` DATETIME(3) NOT NULL,
    `gender` ENUM('Male', 'Female') NOT NULL,
    `address` VARCHAR(191) NOT NULL,
    `kk_id` INTEGER NULL,
    `nik` VARCHAR(191) NOT NULL,
    `create_by` INTEGER NOT NULL,
    `create_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `update_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Citizen_id_key`(`id`),
    UNIQUE INDEX `Citizen_nik_key`(`nik`),
    INDEX `Citizen_create_by_fkey`(`create_by`),
    INDEX `Citizen_kk_id_fkey`(`kk_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `kk` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `head_of_family` VARCHAR(191) NOT NULL,
    `kk` VARCHAR(191) NOT NULL,
    `create_by` INTEGER NOT NULL,
    `create_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `update_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `KK_id_key`(`id`),
    UNIQUE INDEX `KK_kk_key`(`kk`),
    INDEX `KK_create_by_fkey`(`create_by`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `log` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `user_id` INTEGER NOT NULL,
    `action` ENUM('LOGOUT', 'LOGIN', 'CREATE', 'UPDATE', 'DELETE') NOT NULL,
    `description` VARCHAR(191) NOT NULL,
    `create_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `Log_id_key`(`id`),
    INDEX `Log_user_id_fkey`(`user_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `notification` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NOT NULL,
    `date` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `create_by` INTEGER NOT NULL,
    `create_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `update_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Notification_id_key`(`id`),
    INDEX `Notification_create_by_fkey`(`create_by`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `refreshtoken` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `user_id` INTEGER NOT NULL,
    `refresh_token` VARCHAR(1024) NOT NULL,
    `create_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `update_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `RefreshToken_id_key`(`id`),
    INDEX `RefreshToken_user_id_fkey`(`user_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `user` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `email` VARCHAR(191) NOT NULL,
    `username` VARCHAR(191) NOT NULL,
    `password` VARCHAR(191) NOT NULL,
    `user_status` ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
    `role` ENUM('Admin', 'User') NOT NULL DEFAULT 'User',
    `otp` INTEGER NULL,
    `create_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `update_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `User_id_key`(`id`),
    UNIQUE INDEX `User_email_key`(`email`),
    UNIQUE INDEX `user_username`(`username`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `applicationletter` ADD CONSTRAINT `ApplicationLetter_create_by_fkey` FOREIGN KEY (`create_by`) REFERENCES `user`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `cashflow` ADD CONSTRAINT `CashFlow_create_by_fkey` FOREIGN KEY (`create_by`) REFERENCES `user`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `citizen` ADD CONSTRAINT `Citizen_create_by_fkey` FOREIGN KEY (`create_by`) REFERENCES `user`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `citizen` ADD CONSTRAINT `Citizen_kk_id_fkey` FOREIGN KEY (`kk_id`) REFERENCES `kk`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `kk` ADD CONSTRAINT `KK_create_by_fkey` FOREIGN KEY (`create_by`) REFERENCES `user`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `log` ADD CONSTRAINT `Log_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `notification` ADD CONSTRAINT `Notification_create_by_fkey` FOREIGN KEY (`create_by`) REFERENCES `user`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `refreshtoken` ADD CONSTRAINT `RefreshToken_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
