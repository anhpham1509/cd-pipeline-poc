import {configure} from "enzyme";
import Adapter from "enzyme-adapter-react-16";

configure({adapter: new Adapter()});

window.matchMedia =
  window.matchMedia ||
  function() {
    return {
      matches: false,
      addListener: function() {},
      removeListener: function() {},
    };
  };

const errHandler = (...args) => {
  throw new Error(args.join(" "));
};

console.error = errHandler;
console.warning = errHandler;
