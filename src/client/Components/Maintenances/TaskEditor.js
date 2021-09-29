import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Form,
  Card,
} from "react-bootstrap";
import Modal from "react-modal";

import { BsFillXSquareFill, BsThreeDotsVertical } from "react-icons/bs";
import "./Maintenances.css";
import "react-confirm-alert/src/react-confirm-alert.css"; // Import css

import { confirmAlert } from "react-confirm-alert"; // Import
import "react-confirm-alert/src/react-confirm-alert.css"; // Import css

class TaskEditor extends Component {
  constructor(props) {
    super(props);
    this.showReminder = this.showReminder.bind(this);
    this.state = {
      id: this.props.task.id,
      task: this.props.task.task,
      recurring: this.props.task.recurring,
      reminderAt: this.props.task.reminderAt,
      priority: this.props.task.priority,
      showModal: false,
    };

    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
    this.showReminder();
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  handleSubmit = (event) => {
    if (this.state.reminderAt < 1) {
      alert(
        "Mantenimiento preventivo necesita ser recordado cada un dia, minimo."
      );
    } else {
      event.preventDefault();
      fetch("https://www.mantenimientoscvm.com//machines/editMaintenanceTask", {
        method: "POST",
        credentials: "same-origin",
        body: JSON.stringify(this.state),
        headers: {
          "Content-Type": "application/json",
        },
      })
        .then((res) => res.json())
        .then((res) => {
          this.props.getMaintenances();
          this.handleCloseModal();
        });
    }
  };

  delete = () => {
    confirmAlert({
      title: "Confirmar",
      message: "Seguro que quieres borrar esto?",
      buttons: [
        {
          label: "Yes",
          onClick: () =>
            fetch(
              "https://www.mantenimientoscvm.com//machines/deleteMaintenanceTask",
              {
                method: "POST",
                credentials: "same-origin",
                body: JSON.stringify(this.state),
                headers: {
                  "Content-Type": "application/json",
                },
              }
            )
              .then((res) => res.json())
              .then((res) => {
                this.props.getMaintenances();
              }),
        },
        {
          label: "No",
          onClick: () => console.log(),
        },
      ],
    });
  };

  handleOpenModal() {
    this.setState({ showModal: true });
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }

  validateForm() {
    return (
      this.state.task.length > 0 &&
      this.state.priority !== null &&
      this.state.reminderAt > 0
    );
  }

  showReminder() {
    return (
      <FormGroup controlId="reminderAt">
        <FormLabel>Recordar Cada:</FormLabel>
        <FormControl
          autoFocus
          type="type"
          value={this.state.reminderAt}
          onChange={this.handleChange}
        />
        Dias
      </FormGroup>
    );
  }

  render() {
    return (
      <div>
        <BsThreeDotsVertical onClick={this.handleOpenModal} />

        <Modal
          shouldCloseOnOverlayClick
          onRequestClose={this.handleCloseModal}
          isOpen={this.state.showModal}
          className="modal-form"
        >
          <Card>
            <Card.Body>
              <h1 id="justice">
                <b>Editar Mantenimiento Preventivo</b>
              </h1>
              <br />
              <form onSubmit={this.handleSubmit} className="body">
                <FormGroup controlId="task">
                  <FormLabel>Tarea</FormLabel>
                  <FormControl
                    autoFocus
                    type="type"
                    value={this.state.task}
                    onChange={this.handleChange}
                  />
                </FormGroup>

                {this.showReminder()}

                <Button
                  block
                  disabled={!this.validateForm()}
                  type="submit"
                  onClick={this.onSubmit}
                >
                  Actualizar
                </Button>
                <Button
                  block
                  disabled={!this.validateForm()}
                  variant="danger"
                  onClick={this.delete}
                >
                  Borrar
                </Button>
              </form>
            </Card.Body>
          </Card>
        </Modal>
      </div>
    );
  }
}
export default TaskEditor;
