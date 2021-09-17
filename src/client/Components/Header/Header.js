import React, { Component } from "react";
import {
  Navbar,
  Nav,
  NavDropdown,
  Form,
  FormControl,
  Button,
  FormGroup,
} from "react-bootstrap";
import "./Header.css";
import { withRouter } from "react-router";
import { retrieveCookie, deleteCookie } from "../Cookies";

class Header extends Component {
  constructor(props) {
    super(props);
    console.log(props);
    this.state = {};
  }

  render() {
    const { location } = this.props;
    return (
      <Navbar className="navber" expand="lg">
        <Navbar.Brand href="">XXXXX</Navbar.Brand>
        <Navbar.Toggle aria-controls="basic-navbar-nav" />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav className="mr-auto" activeKey={location.pathname}>
            <Nav.Link href="/Home">Home</Nav.Link>
            <Nav.Link href="/Routes">Routes</Nav.Link>
            <Nav.Link href="/Machines">Machines</Nav.Link>
            <Nav.Link href="/Definitions">Definitions</Nav.Link>
          </Nav>
        </Navbar.Collapse>
      </Navbar>
    );
  }
}

export default withRouter(Header);
