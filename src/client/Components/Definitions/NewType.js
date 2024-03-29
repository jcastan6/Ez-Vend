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

class NewType extends Component {
  constructor(props) {
    super(props);
    this.state = {
      type: "",
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
    fetch("https://www.mantenimientoscvm.com/machines/newType", {
      method: "POST",
      credentials: "same-origin",
      body: JSON.stringify(this.state),
      headers: {
        "Content-Type": "application/json",
      },
    }).then(() => {
      this.setState({
        type: "",
      });
      this.props.getTypes();
    });
  };

  validateForm() {
    return this.state.type.length > 0;
  }

  render() {
    return (
      <div>
        <h1 id="justice">
          <b>Agregar Tipo de Maquina</b>
        </h1>
        <br />
        <form onSubmit={this.handleSubmit}>
          <FormGroup className="userId" controlId="type">
            <FormLabel>Tipo de Maquina</FormLabel>
            <FormControl
              autoFocus
              type="type"
              value={this.state.type}
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
export default withRouter(NewType);
