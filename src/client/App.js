import React, { Component } from "react";
import { BrowserRouter, Route } from "react-router-dom";

import Login from "./Login";
import Register from "./Registration";
import Home from "./Home";
import Clients from "./Clients";
import Machines from "./Machines";
import Routes from "./Routes";

import Definitions from "./Definitions";
import "./app.css";
import Search from "./Search";

export default class Routing extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <BrowserRouter>
        <Route
          exact
          path="/"
          render={(props) => <Login {...props} component={Login} />}
        />
        <Route component={Home} path="/Home" />
        <Route component={Register} path="/Registration" />
        <Route component={Clients} path="/Clients" />
        <Route component={Machines} path="/Machines" />
        <Route component={Definitions} path="/Definitions" />
        <Route component={Routes} path="/Routes" />
      </BrowserRouter>
    );
  }
}
