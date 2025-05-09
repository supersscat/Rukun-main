import { User } from '~/server/model/User';
import { readBody } from 'h3';

export default defineEventHandler(async (event) => {
  const body = await readBody(event);

  const { username, email } = body;

  if (!username && !email) {
    return {
      usernameTaken: false,
      emailTaken: false
    };
  }

  const { usernameTaken, emailTaken } = await User.findUserByUsernameOrEmail(username, email);

  return { usernameTaken, emailTaken };
});




