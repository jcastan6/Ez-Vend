import React, { Component } from "react";
import { BrowserRouter, Route } from "react-router-dom";

import Login from "./Login";
import Register from "./Registration";
import Home from "./Home";
import Clients from "./Clients";
import Machines from "./Machines";
import Routes from "./Routes";
import Definitions from "./Definitions";
import Search from "./Search";
import Header from "./Components/Header/Header";

import MobileHome from "./Mobile-Components/Home";

import "./app.css";

export default class Routing extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <BrowserRouter>
        <Header />
        <Route
          exact
          path="/"
          render={(props) => <Login {...props} component={Login} />}
        />
        <Route component={Home} path="/home" />
        <Route component={Register} path="/registration" />
        <Route component={Clients} path="/clients" />
        <Route component={Machines} path="/machines" />
        <Route component={Definitions} path="/definitions" />
        <Route component={Routes} path="/routes" />

        <Route component={MobileHome} path="mobile/" />
      </BrowserRouter>
    );
  }
}
