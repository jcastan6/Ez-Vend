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

class NewMachine extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.state = {
      type: "",
      businessName: "adminbusiness",
      types: [],
      attributes: [],
    };
    this.getTypes = this.getTypes.bind(this);
    this.getAttributes = this.getAttributes.bind(this);
    this.getTypes();
    this.getAttributes();
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  handleSubmit = (event) => {
    event.preventDefault();
    fetch("http://localhost:4000/machines/newMachine", {
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

  getTypes() {
    fetch(`http://localhost:4000/machines/getTypes/`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        let types = [];

        res.forEach((element) => {
          types.push(<option>{element.type}</option>);
        });

        this.setState({
          types: types,
        }),
          () => console.log();
      });
  }

  getAttributes() {
    fetch(`http://localhost:4000/machines/getMachineAttributes/`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        let attributes = [];
        res.forEach((element) => {
          attributes.push(
            <FormGroup>
              <FormLabel>{element}</FormLabel>
              <FormControl as="textarea" rows={1} />
            </FormGroup>
          );
        });

        this.setState({
          attributes: attributes,
        }),
          () => console.log();
      });
  }

  render() {
    return (
      <div>
        <h1 id="justice">
          <b>Add New Machine</b>
        </h1>
        <br />
        <form onSubmit={this.handleSubmit}>
          <FormGroup className="userId" controlId="type">
            <FormLabel>Machine Type</FormLabel>
            <FormControl as="select" size="lg">
              {this.state.types}
            </FormControl>
          </FormGroup>

          {this.state.attributes}

          <Button
            block
            disabled={!this.validateForm()}
            type="submit"
            onClick={this.onSubmit}
          >
            Agregar
          </Button>
        </form>
      </div>
    );
  }
}
export default withRouter(NewMachine);
