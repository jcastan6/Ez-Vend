import Cookies from "universal-cookie";

global.cookie = new Cookies();

export const saveCookie = (value) => {
  global.cookie.set("secret", value, {
    path: "/",
    maxAge: 1800,
  });
};

export const deleteCookie = () => {
  global.cookie.remove("secret", {
    path: "/",
  });
};

export const retrieveCookie = () => {
  if (global.cookie.get("secret")) {
    return true;
  }
  return false;
};
