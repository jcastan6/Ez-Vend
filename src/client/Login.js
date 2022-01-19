import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Image,
  Carousel,
} from "react-bootstrap";

import { saveCookie } from "./Components/Cookies";

class Login extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.state = {
      username: "",
      password: "",
    };
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  handleSubmit = (event) => {
    event.preventDefault();
    fetch("https://www.mantenimientoscvm.com/users/login", {
      method: "POST",
      credentials: "same-origin",
      body: JSON.stringify(this.state),
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((res) => res.json())
      .then((res) => {
        if (res.status === 401) {
          alert("Usuario y contraseña no fueron encontrados");
        } else if (res.username) {
          saveCookie(res.username);
          this.handleRouteChange();
        } else {
          const error = new Error(res.error);
          throw error;
        }
      })
      .catch((err) => {
        alert("Hubo un error al iniciar la sesión");
        console.error(err);
      });
  };

  handleRouteChange() {
    this.props.history.push("/Home");
  }

  validateForm() {
    return this.state.username.length > 0 && this.state.password.length > 0;
  }

  render() {
    return (
      <div className="body login">
        <h1 id="justice">
          <img
            src="https://storage.googleapis.com/ezvend/cvm.png"
            width="100%"
            className="d-inline-block align-top"
            alt="CVM"
          />{" "}
        </h1>
        <br />
        <form onSubmit={this.handleSubmit}>
          <FormGroup className="username" controlId="username">
            <FormLabel>Usuario</FormLabel>
            <FormControl
              autoFocus
              type="username"
              value={this.state.username}
              onChange={this.handleChange}
            />
          </FormGroup>
          <FormGroup controlId="password">
            <FormLabel>Contraseña</FormLabel>
            <FormControl
              value={this.state.password}
              onChange={this.handleChange}
              type="password"
              data-toggle="password"
            />
          </FormGroup>
          <Button
            block
            disabled={!this.validateForm()}
            type="submit"
            onClick={this.onSubmit}
          >
            Iniciar Sesión
          </Button>
          <Link to="/Registration" className="small">
            Crear Cuenta
          </Link>
        </form>
      </div>
    );
  }
}
export default withRouter(Login);
