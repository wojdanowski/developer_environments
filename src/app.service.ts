import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    return `Hello World! Build from branch: ${process.env.TF_VAR_BRANCH_NAME} 🥑`;
  }
}
