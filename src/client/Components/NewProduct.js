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
import "../app.css";

export default class NewProduct extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.state = {
      name: "",
      businessName: "adminbusiness",
    };
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  handleSubmit = (event) => {
    event.preventDefault();
    fetch("http://192.168.1.153:4000/products/newProduct", {
      method: "POST",
      credentials: "same-origin",
      body: JSON.stringify(this.state),
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((res) => res.json())
      .then((res) => {
        this.handleRouteChange();
      });
  };

  handleRouteChange() {
    window.location.reload(false);
  }

  validateForm() {
    return this.state.type.length > 0;
  }

  render() {
    return (
      <div>
        <h1 id="justice">
          <b>Add New Machine</b>
        </h1>
        <br />
        <form onSubmit={this.handleSubmit}>
          <FormGroup className="userId" controlId="name">
            <FormLabel>Machine Type</FormLabel>
            <FormControl
              autoFocus
              type="name"
              value={this.state.name}
              onChange={this.handleChange}
            />
          </FormGroup>

          <Button
            block
            disabled={!this.validateForm()}
            type="submit"
            onClick={this.onSubmit}
          >
            Login
          </Button>
        </form>
      </div>
    );
  }
}
