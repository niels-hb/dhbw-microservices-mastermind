import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import * as jwt from 'jsonwebtoken';
import { env } from '../shared/env';

export const User = createParamDecorator((data: string, ctx: ExecutionContext) => {
  const req = ctx.switchToHttp().getRequest();

  // if route is protected, there is a user set in auth.middleware
  if (!!req.user) {
    return !!data ? req.user[data] : req.user;
  }

  // in case a route is not protected, we still want to get the optional auth user from jwt
  if (req.headers) {
    const token = req.headers.authorization ? (req.headers.authorization as string).split(' ') : undefined;
    if (token && token[1]) {
      const decoded: any = jwt.verify(token[1], env.app.secret);
      return !!data ? decoded[data] : decoded.user;
    }
  }
});
