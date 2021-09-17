import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Form,
} from "react-bootstrap";
import "../Definitions.css";

class ClientEditor extends Component {
  constructor(props) {
    super(props);

    this.state = {
      id: this.props.client.id,
      name: this.props.client.name,
    };
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  handleSubmit = (event) => {
    event.preventDefault();

    fetch("http://localhost:4000/clients/editClient", {
      method: "POST",
      credentials: "same-origin",
      body: JSON.stringify(this.state),
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((res) => res.json())
      .then((res) => {
        this.props.getClients();
      });
  };

  delete = () => {
    fetch("http://localhost:4000/clients/deleteClient", {
      method: "POST",
      credentials: "same-origin",
      body: JSON.stringify(this.state),
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((res) => res.json())
      .then((res) => {
        this.props.getClients();
      });
  };

  validateForm() {
    return this.state.name.length > 0;
  }

  render() {
    return (
      <div className="tab-panel">
        <h1 id="justice">
          <b>Edit Client</b>
        </h1>
        <br />
        <form onSubmit={this.handleSubmit} className="body">
          <FormGroup controlId="name">
            <FormLabel>Name</FormLabel>
            <FormControl
              autoFocus
              type="type"
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
            Update
          </Button>
          <Button
            block
            disabled={!this.validateForm()}
            variant="danger"
            onClick={this.delete}
          >
            Delete
          </Button>
        </form>
      </div>
    );
  }
}
export default withRouter(ClientEditor);
