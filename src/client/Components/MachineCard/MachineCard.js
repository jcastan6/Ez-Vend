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
  Jumbotron
} from "react-bootstrap";

export default class MachineCard extends Component {
  constructor(props) {
    super(props);
    this.state = {
      machineid: this.props.machineid,
      type: this.props.type,
      client: this.props.client
    };
  }

  render() {
    return (
      <a href={`/Machine/${this.state.machineid}`}>
        <Card style={{ width: "18rem" }}>
          <Card.Body>
            <Card.Title>{this.state.machineid}</Card.Title>
            <Card.Title>{this.state.type}</Card.Title>
            <Card.Text>{this.state.client}</Card.Text>
          </Card.Body>
        </Card>
      </a>
    );
  }
}
