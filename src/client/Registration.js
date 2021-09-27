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
      fetch("http://54.177.22.144:3001/users/register", {
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
            alert("Secret does not match.");
          } else if (res.status === 200) {
            this.handleRouteChange();
          } else {
            const error = new Error(res.error);
            throw error;
          }
        })
        .catch((err) => {
          alert("Error logging in please try again");
          console.error(err);
        });
    }
  };

  handleRouteChange() {
    this.props.history.push("/");
  }

  validateForm() {
    return this.state.username.length > 0 && this.state.password.length > 8;
  }

  render() {
    return (
      <div className="body">
        <h1 id="justice">
          <b>Register</b>
        </h1>
        <br />
        <form onSubmit={this.handleSubmit}>
          <FormGroup className="username" controlId="username">
            <FormLabel>Username</FormLabel>
            <FormControl
              autoFocus
              type="username"
              value={this.state.username}
              onChange={this.handleChange}
            />
          </FormGroup>
          <FormGroup controlId="password">
            <FormLabel>Password</FormLabel>
            <FormControl
              value={this.state.password}
              onChange={this.handleChange}
              type="password"
              data-toggle="password"
            />
          </FormGroup>
          <FormGroup controlId="validatePass">
            <FormLabel>Validate Password</FormLabel>
            <FormControl
              value={this.state.validatePass}
              onChange={this.handleChange}
              type="password"
              data-toggle="password"
            />
          </FormGroup>
          <FormGroup controlId="secret">
            <FormLabel>Secret</FormLabel>
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
            Submit
          </Button>
          <Link to="/" className="small">
            Already Have an Account?
          </Link>
        </form>
      </div>
    );
  }
}
export default withRouter(Registration);
