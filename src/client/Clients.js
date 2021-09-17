import React, { Component } from "react";
import Header from "./Components/Header/Header.js";
import { retrieveCookie } from "./Components/Cookies";
import ClientCard from "./Components/ClientCard/ClientCard";

import { Container, Jumbotron, Row, Col, Button } from "react-bootstrap";

export default class Clients extends Component {
  constructor(props) {
    super(props);
    this.state = {
      user: retrieveCookie(),
      clients: [],
      business: "adminbusiness",
    };

    this.getMachines();
    this.renderMachines = this.renderMachines.bind(this);
  }

  getMachines() {
    fetch(`http://localhost:4000/clients/getAll/${this.state.business}`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        this.setState(
          {
            clients: res,
          },
          () => console.log()
        );
      });
  }

  renderMachines() {
    const latest = [];
    for (let i = 0; i < this.state.clients.length; i++) {
      latest.push(
        <Col className="post-card">
          <ClientCard
            id={this.state.clients[i].id}
            name={this.state.clients[i].name}
          />
        </Col>
      );
    }
    return latest;
  }

  render() {
    return (
      <div>
        <Jumbotron>
          <h1>All of your clients, listed by last added</h1>
          <p>clicking on a client will give you more details</p>
        </Jumbotron>
        <Button> New Client </Button>
        {this.renderMachines()}
      </div>
    );
  }
}
