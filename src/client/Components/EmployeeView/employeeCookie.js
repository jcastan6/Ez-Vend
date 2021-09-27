import Cookies from "universal-cookie";

global.cookie = new Cookies();

export const saveCookie = (value, value2) => {
  global.cookie.set("secret", value, {
    path: "/",
    maxAge: 1800,
  });
  global.cookie.set("user", value2, {
    path: "/",
    maxAge: 1800,
  });
};

export const deleteCookie = () => {
  global.cookie.remove("secret", {
    path: "/",
  });
  global.cookie.remove("user", {
    path: "/",
    maxAge: 1800,
  });
};

export const retrieveCookie = () => {
  if (global.cookie.get("secret")) {
    return { secret: true, user: global.cookie.get("user") };
  }

  return false;
};
