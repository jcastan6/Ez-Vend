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

export default class NewEmployee extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.toggleTechnician = this.toggleTechnician.bind(this);
    this.getTypes = this.getTypes.bind(this);

    this.state = {
      name: "",
      type: "",
      username: "",
      isTechnician: false,
      types: [],
    };
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  handleSubmit = (event) => {
    event.preventDefault();
    fetch("https://www.mantenimientoscvm.com/users/addEmployee", {
      method: "POST",
      credentials: "same-origin",
      body: JSON.stringify(this.state),
      headers: {
        "Content-Type": "application/json",
      },
    }).then((res) => {
      if (res.status === 400) {
        alert("Username already exists.");
      } else {
        this.setState({
          name: "",
          type: "",
          username: "",
          isTechnician: false,
        });

        this.props.getEmployees();
      }
    });
  };

  handleRouteChange() {
    window.location.reload(false);
  }

  validateForm() {
    return this.state.name.length > 0;
  }

  getTypes() {
    fetch(`https://www.mantenimientoscvm.com/machines/getTypes/`, {
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
          type: types[0].props.children,
        }),
          () => console.log();
      });
  }

  isTechnician() {
    if (this.state.isTechnician === true) {
      return (
        <FormGroup className="userId" controlId="type">
          <FormLabel>Type</FormLabel>
          <FormControl
            as="select"
            size="lg"
            value={this.state.type}
            onChange={this.handleChange}
          >
            {this.state.types}
          </FormControl>
        </FormGroup>
      );
    }
  }

  toggleTechnician() {
    this.getTypes();
    this.setState({
      isTechnician: !this.state.isTechnician,
    });
  }

  render() {
    return (
      <div>
        <h1 id="justice">
          <b>Agregar Empleado</b>
        </h1>
        <br />
        <form onSubmit={this.handleSubmit}>
          <FormGroup className="userId" controlId="name">
            <FormLabel>Nombre</FormLabel>
            <FormControl
              autoFocus
              type="name"
              value={this.state.name}
              onChange={this.handleChange}
            />
          </FormGroup>
          <FormGroup className="userId" controlId="username">
            <FormLabel>Usuario</FormLabel>
            <FormControl
              autoFocus
              type="input"
              value={this.state.username}
              onChange={this.handleChange}
            />
          </FormGroup>

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
