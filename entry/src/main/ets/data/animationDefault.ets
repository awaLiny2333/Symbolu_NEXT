import Curves from '@ohos.curves';

/**
 * Default animation params.
 * @returns An AnimateParam
 * */
export function animationDefault() {
  let spring = Curves.springMotion(0.36, 0.8);
  let ap: AnimateParam = { curve: spring };
  return ap;
}