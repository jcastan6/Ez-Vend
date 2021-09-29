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
    this.state = {
      username: retrieveCookie(),
    };

    if (!this.state.username) {
      alert("Not logged in.");
      this.props.history.push("/");
    }
  }

  render() {
    const { location } = this.props;
    return (
      <Navbar className="navbar" expand="lg">
        <Navbar.Brand>
          <img
            src="https://storage.googleapis.com/ezvend/cvm.png"
            width="100"
            className="d-inline-block align-top"
            alt="CVM"
          />
        </Navbar.Brand>
        <Navbar.Toggle aria-controls="basic-navbar-nav" />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav className="mr-auto" activeKey={location.pathname}>
            <Nav.Link href="/Home">Inicio</Nav.Link>
            <Nav.Link href="/Routes">Rutas</Nav.Link>
            <Nav.Link href="/Machines">Maquinas</Nav.Link>
            <Nav.Link href="/Definitions">Definiciones</Nav.Link>
          </Nav>
        </Navbar.Collapse>
        <Navbar.Collapse className="justify-content-end">
          <Navbar.Text>
            <a href="/" onClick={() => deleteCookie()}>
              Cerrar Sesión
            </a>
          </Navbar.Text>
        </Navbar.Collapse>
      </Navbar>
    );
  }
}

export default withRouter(Header);
