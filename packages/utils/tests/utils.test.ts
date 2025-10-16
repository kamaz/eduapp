import { assert, clamp } from '../src/index';

import { describe, expect, it } from 'vitest';

describe('utils', () => {
  it('clamp bounds numbers', () => {
    expect(clamp(5, 0, 10)).toBe(5);
    expect(clamp(-5, 0, 10)).toBe(0);
    expect(clamp(15, 0, 10)).toBe(10);
  });

  it('assert throws on falsey', () => {
    expect(() => assert(false, 'boom')).toThrowError('boom');
  });
});

