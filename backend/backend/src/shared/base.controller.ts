import * as jwt from 'jsonwebtoken';
import { env } from './env';

export class BaseController {
  protected getUserIdFromToken(authorization: any): any {
    if (!authorization) {
      return undefined;
    }

    const token = authorization.split(' ')[1];
    const decoded: any = jwt.verify(token, env.app.secret);
    return decoded.id;
  }
}
