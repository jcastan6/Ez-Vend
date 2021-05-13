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

import { retrieveCookie, deleteCookie } from "../Cookies";

export default class Header extends Component {
  constructor(props) {
    super(props);
    console.log(props);
    this.state = {
      user: retrieveCookie(),
      searchParams: "",
    };
    this.isLoggedIn = this.isLoggedIn.bind(this);
    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
  }

  handleOpenModal() {
    this.setState({ showModal: true });
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }

  logout() {
    deleteCookie();
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  submitHandler(e) {
    e.preventDefault();
  }

  isLoggedIn() {
    return (
      <Navbar bg="light" expand="lg">
        <Navbar.Brand href="">XXXXX</Navbar.Brand>
        <Navbar.Toggle aria-controls="basic-navbar-nav" />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav className="mr-auto">
            <Nav.Link href="Home">Home</Nav.Link>
            <Nav.Link href="Routes">Routes</Nav.Link>
            <Nav.Link href="Machines">Machines</Nav.Link>
            <Nav.Link href="Definitions">Definitions</Nav.Link>
          </Nav>
          {/* <Form inline onSubmit={this.submitHandler}>
            <NavDropdown title={this.state.user} id="basic-nav-dropdown">
              <NavDropdown.Item href="/Definitions">
                Definitions
              </NavDropdown.Item>

              <NavDropdown.Divider />
              <NavDropdown.Item href="/" onClick={() => this.logout()}>
                Log Out
              </NavDropdown.Item>
            </NavDropdown>
            <FormGroup className="mr-sm-2" controlId="searchParams">
              <FormControl
                autoFocus
                placeholder="Search"
                value={this.state.searchParams}
                onChange={this.handleChange}
              />
            </FormGroup>

            <a href={`/Search/${this.state.searchParams}`}>
              <Button variant="outline-success" type="button">
                Search
              </Button>
            </a>
          </Form> */}
        </Navbar.Collapse>
      </Navbar>
    );
  }

  render() {
    return this.isLoggedIn();
  }
}
