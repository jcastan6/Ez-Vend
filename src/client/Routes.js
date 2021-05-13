import React, { Component } from "react";
import Header from "./Components/Header/Header";
import { retrieveCookie } from "./Components/Cookies";
import Modal from "react-modal";
import MachineCard from "./Components/MachineCard/MachineCard";
import NewMachine from "./Components/NewMachine";
import { Container, Jumbotron, Row, Col, Button } from "react-bootstrap";

export default class Routes extends Component {
  constructor(props) {
    super(props);
    this.state = {
      user: retrieveCookie(),
      machines: [],
      business: "adminbusiness",
    };

    this.getMachines();
    this.renderMachines = this.renderMachines.bind(this);

    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
  }

  handleOpenModal() {
    this.setState({ showModal: true });
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }
  getMachines() {
    fetch(`http://localhost:4000/machines/getAll/${this.state.business}`, {
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
            machines: res,
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
        <div className="body">
          <Modal shouldCloseOnOverlayClick isOpen={this.state.showModal}>
            <Button variant="outline-primary" onClick={this.handleCloseModal}>
              X
            </Button>
            <NewMachine history={this.props.history} />
          </Modal>
          <Jumbotron>
            <h1>All of your machines, listed by first added</h1>
            <p>clicking on a machine will give you more details</p>
          </Jumbotron>
          <Button onClick={this.handleOpenModal}>New Machine</Button>
          {this.renderMachines()}
        </div>
      </div>
    );
  }
}
