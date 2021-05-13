import React, { Component } from "react";
import { Heart, ChatSquare, HeartFill } from "react-bootstrap-icons";
import {
  Card,
  Navbar,
  Nav,
  NavDropdown,
  Form,
  FormControl,
  Button,
  Jumbotron,
} from "react-bootstrap";

export default class ClientCard extends Component {
  constructor(props) {
    super(props);
    this.state = {
      id: this.props.id,
      name: this.props.name,
      machines: this.props.machines,
    };
  }

  render() {
    return (
      <a href={`/Client/${this.state.id}`}>
        <Card style={{ width: "18rem" }}>
          <Card.Body>
            <Card.Title>{this.state.id}</Card.Title>
            <Card.Title>{this.state.name}</Card.Title>
            <Card.Text>{this.state.client}</Card.Text>
          </Card.Body>
        </Card>
      </a>
    );
  }
}
