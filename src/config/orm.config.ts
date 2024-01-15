import { DataSourceOptions } from 'typeorm';

const mysqlConfig: DataSourceOptions = {
  type: 'mysql',
  host: process.env.DB_HOST || '127.0.0.1',
  port: parseInt(process.env.DB_PORT, 10) || 3307,
  username: process.env.DB_USER || 'root',
  password: process.env.DB_PASS || 'root',
  database: process.env.DB_NAME || 'development',
  entities: [`${__dirname}/../data/entity/*.entity{.ts,.js}`],
  migrations: [`${__dirname}/../data/migration/**/*{.ts,.js}`],
  subscribers: [`${__dirname}/../data/subscriber/**/*{.ts,.js}`],
  logging: true,
  synchronize: false,
  charset: 'utf8mb4',
  extra: {
    connectionLimit: databaseConnectionLimit(),
  },
};

function databaseConnectionLimit(): number {
  return parseInt(process.env.DB_CONNECTION_LIMIT, 10) || 2;
}

export = mysqlConfig;
