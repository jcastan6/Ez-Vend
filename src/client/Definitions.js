import React, { Component } from "react";
import { Card, Container, Jumbotron, Row, Col, Button } from "react-bootstrap";

import Header from "./Components/Header/Header";
import { retrieveCookie } from "./Components/Cookies";

import "react-data-table-component-extensions/dist/index.css";
import "./app.css";
import "react-web-tabs/dist/react-web-tabs.css";

import MachineTypes from "./Components/Definitions/MachineTypes";
import Clients from "./Components/Definitions/Clients";
import Employees from "./Components/Definitions/Employees";

export default class Definitions extends Component {
  constructor(props) {
    super(props);
    this.state = {
      user: retrieveCookie(),
    };
  }

  render() {
    return (
      <div>
        <Header />
        <div className="body">
          <Container fluid>
            <h1>Machine Types</h1>
            <br />
            <MachineTypes />
          </Container>

          <Container fluid>
            <h1>Clients</h1>
            <br />
            <Clients />
            <p />
          </Container>

          <Container fluid>
            <h1>Employees</h1>
            <br />
            <Employees />
            <p />
          </Container>
        </div>
      </div>
    );
  }
}
