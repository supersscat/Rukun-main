import { KK } from '~/server/model/KK';
import { readBody } from 'h3';

export default defineEventHandler(async (event) => {
  const body = await readBody(event);

  const {kk } = body;

  if (!kk) {
    return { 
      kkTaken: false
    };
  }

  const { kkTaken } = await KK.findKKByHeadOrNumber(kk); 

  return {kkTaken };
});
