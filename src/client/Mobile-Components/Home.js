import React, { Component } from "react";
import { Container, Jumbotron, Row, Col } from "react-bootstrap";
import Header from "../Components/Header/Header.js";
import { retrieveCookie } from "../Components/Cookies";

export default class MobileHome extends Component {
  constructor(props) {}

  render() {
    return (
      <div>
        <Jumbotron />
        <Container fluid />
      </div>
    );
  }
}
