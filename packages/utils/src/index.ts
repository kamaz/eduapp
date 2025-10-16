export const assert = (condition: unknown, message = 'Assertion failed'): asserts condition => {
  if (!condition) throw new Error(message);
};

export const clamp = (value: number, min: number, max: number) => Math.min(Math.max(value, min), max);

