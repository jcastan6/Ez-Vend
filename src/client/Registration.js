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

class Registration extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.state = {
      username: "",
      password: "",
      validatePass: "",
      secret: "",
    };
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  handleSubmit = (event) => {
    event.preventDefault();
    if (this.validateForm()) {
      fetch("https://www.mantenimientoscvm.com//users/register", {
        method: "POST",
        credentials: "same-origin",
        body: JSON.stringify(this.state),
        headers: {
          "Content-Type": "application/json",
        },
      })
        .then((res) => res.json())
        .then((res) => {
          if (res.status === 400) {
            alert("Sorry please check log-in credentials");
          }
          if (res.status === 401) {
            alert("El secreto no coincide con la base de datos.");
          } else if (res.status === 200) {
            this.handleRouteChange();
          } else {
            const error = new Error(res.error);
            throw error;
          }
        })
        .catch((err) => {
          alert("Error al crear la cuenta.");
          console.error(err);
        });
    }
  };

  handleRouteChange() {
    this.props.history.push("/");
  }

  validateForm() {
    return (
      this.state.username.length > 0 &&
      this.state.password.length > 8 &&
      this.state.validatePass === this.state.password
    );
  }

  render() {
    return (
      <div className="body login">
        <h1 id="justice">
          <b>Registrar</b>
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
          <FormGroup controlId="validatePass">
            <FormLabel>Validar Contraseña</FormLabel>
            <FormControl
              value={this.state.validatePass}
              onChange={this.handleChange}
              type="password"
              data-toggle="password"
            />
          </FormGroup>
          <FormGroup controlId="secret">
            <FormLabel>Secreto</FormLabel>
            <FormControl
              value={this.state.secret}
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
            Crear Cuenta
          </Button>
          <Link to="/" className="small">
            Ya tengo Cuenta.
          </Link>
        </form>
      </div>
    );
  }
}
export default withRouter(Registration);
