import type { ApiResponse } from '../src/index';
import { describe, expect, it } from 'vitest';

function makeOk<T>(data: T): ApiResponse<T> {
  return { ok: true, data };
}

describe('schema ApiResponse', () => {
  it('wraps data with ok flag', () => {
    const res = makeOk({ x: 1 });
    expect(res.ok).toBe(true);
    expect(res.data?.x).toBe(1);
  });
});

