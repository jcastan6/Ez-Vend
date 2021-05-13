import React, { Component } from "react";
import Header from "./Components/Header";
import { retrieveCookie } from "./Components/Cookies";
import MachineCard from "./Components/MachineCard";
import { Container, Jumbotron, Row, Col } from "react-bootstrap";

export default class Products extends Component {
  constructor(props) {
    super(props);
    this.state = {
      user: retrieveCookie(),
      products: [],
      business: "adminbusiness"
    };

    this.getMachines();
    this.renderMachines = this.renderMachines.bind(this);
  }

  getMachines() {
    fetch(`http://localhost:4000/products/getAll/${this.state.business}`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json"
      }
    })
      .then(response => response.json())
      .then(res => {
        this.setState(
          {
            machines: res
          },
          () => console.log()
        );
      });
  }

  renderMachines() {
    const latest = [];
    for (let i = 0; i < this.state.machines.length; i++) {
      latest.push(
        <Col className="post-card">
          <MachineCard
            machineid={this.state.machines[i].id}
            type={this.state.machines[i].type}
          />
        </Col>
      );
    }
    return latest;
  }

  render() {
    return (
      <div>
        <Header />
        <Jumbotron>
          <h1>All of your machines, listed by last added</h1>
          <p>clicking on a machine will give you more details</p>
        </Jumbotron>
        {this.renderMachines()}
      </div>
    );
  }
}
