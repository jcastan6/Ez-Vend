import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Card,
} from "react-bootstrap";
import Modal from "react-modal";
import "./Maintenances.css";
import { BsFillPlusSquareFill } from "react-icons/bs";

class NewMaintenance extends Component {
  constructor(props) {
    super(props);
    this.state = {
      machine: this.props.machine,
      task: "",
      priority: null,
      recurring: false,
      reminderCount: null,
      showModal: false,
    };

    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
    console.log(this.state);
  };

  handleSubmit = (event) => {
    if (this.state.reminderCount < 1) {
      alert(
        "Mantenimiento preventivo necesita ser recordado minimo una vez al dia."
      );
    } else {
      event.preventDefault();
      fetch("https://www.mantenimientoscvm.com/machines/newMaintenanceTask", {
        method: "POST",
        credentials: "same-origin",
        body: JSON.stringify(this.state),
        headers: {
          "Content-Type": "application/json",
        },
      }).then(() => {
        this.props.getMaintenances();
        this.handleCloseModal();
      });
    }
  };

  handleOpenModal() {
    this.setState({ showModal: true });
  }

  handleCloseModal() {
    this.setState({ task: "", reminderCount: null, showModal: false });
  }

  validateForm() {
    if (this.state.task.length > 0 && this.state.reminderCount) {
      return true;
    }

    return false;
  }

  render() {
    return (
      <div>
        <h4>
          Mantenimientos Preventivos{" "}
          <BsFillPlusSquareFill
            onClick={this.handleOpenModal}
            className="add"
          />
        </h4>

        <Modal
          shouldCloseOnOverlayClick
          onRequestClose={this.handleCloseModal}
          isOpen={this.state.showModal}
          className="modal-form"
        >
          <Card>
            <Card.Body>
              <h5>Agregar Mantenimiento Preventivo</h5>
              <form onSubmit={this.handleSubmit}>
                <FormGroup controlId="task">
                  <FormLabel>Tarea</FormLabel>
                  <FormControl
                    autoFocus
                    type="type"
                    value={this.state.task}
                    onChange={this.handleChange}
                  />
                </FormGroup>

                <FormGroup controlId="reminderCount">
                  <FormLabel>Recordar Cada:</FormLabel>
                  <FormControl
                    autoFocus
                    type="type"
                    value={this.state.reminderCount}
                    onChange={this.handleChange}
                  />
                  Dias
                </FormGroup>
              </form>
              <Button variant="secondary" onClick={this.handleCloseModal}>
                Cerrar
              </Button>{" "}
              <Button variant="primary" onClick={this.handleSubmit}>
                Enviar
              </Button>
            </Card.Body>
          </Card>
        </Modal>
      </div>
    );
  }
}
export default withRouter(NewMaintenance);
