import dotenv from 'dotenv';
import path from 'path';
import { LoggerOptions } from 'typeorm/logger/LoggerOptions';

dotenv.config({
    path: path.join(process.cwd(),
    `.env${(['test', 'development'].includes(process.env.NODE_ENV) ? `.${process.env.NODE_ENV}` : '')}`
    ),
});

function normalizePortStrict(port: string): number {
    const parsedPort = parseInt(port, 10);
    if (parsedPort >= 0) {
        return parsedPort;
    } else {
        return -1;
    }
}

function getOsEnv(key: string): string {
    if (typeof process.env[key] === 'undefined') {
        throw new Error(`Environment variable ${key} is not set.`);
    }

    return process.env[key] as string;
}

function getOsEnvOptional(key: string): string | undefined {
    return process.env[key];
}

function toBool(value: string): boolean {
    return value === 'true';
}

function toNumber(value: string): number {
    return parseInt(value, 10);
}

function toLoggerOptions(value: string|boolean): LoggerOptions {
    const loggerOptions: string[] = ['true', 'false', 'all', 'query', 'schema', 'error', 'warn', 'info', 'log', 'migration'];
    if (loggerOptions.includes(value.toString())) {
        if (value.toString() === 'true' || value.toString() === 'false') {
            return value as boolean;
        } else {
            return value as any;
        }
    }
    return false;
}

/**
 * Environment variables
 */
export const env = {
    node: process.env.NODE_ENV || 'development',
    isProduction: process.env.NODE_ENV === 'production',
    app: {
        port: normalizePortStrict(process.env.PORT || getOsEnv('APP_PORT')),
        secret: getOsEnv('APP_SECRET'),
    },
    db: {
        type: getOsEnv('TYPEORM_CONNECTION'),
        host: getOsEnvOptional('TYPEORM_HOST'),
        port: toNumber(getOsEnvOptional('TYPEORM_PORT')),
        username: getOsEnvOptional('TYPEORM_USERNAME'),
        password: getOsEnvOptional('TYPEORM_PASSWORD'),
        database: getOsEnv('TYPEORM_DATABASE'),
        synchronize: toBool(getOsEnvOptional('TYPEORM_SYNCHRONIZE')),
        logging: toLoggerOptions(getOsEnv('TYPEORM_LOGGING')),
    },
    swagger: {
        enabled: toBool(getOsEnv('SWAGGER_ENABLED')),
        route: getOsEnv('SWAGGER_ROUTE'),
    },
};
