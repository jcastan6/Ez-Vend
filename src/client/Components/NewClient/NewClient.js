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

export default class NewClient extends Component {
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
    fetch("http://localhost:4000/clients/addClient", {
      method: "POST",
      credentials: "same-origin",
      body: JSON.stringify(this.state),
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((res) => res.json())
      .then((res) => {
        this.setState({
          name: "",
        });
        this.props.getClients();
      });
  };

  handleRouteChange() {
    window.location.reload(false);
  }

  validateForm() {
    return this.state.name.length > 0;
  }

  render() {
    return (
      <div>
        <h1 id="justice">
          <b>Add New Client</b>
        </h1>
        <br />
        <form onSubmit={this.handleSubmit}>
          <FormGroup className="userId" controlId="name">
            <FormLabel>Client Name</FormLabel>
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
            Add
          </Button>
        </form>
      </div>
    );
  }
}
