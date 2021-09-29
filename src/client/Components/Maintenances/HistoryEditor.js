import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import Modal from "react-modal";
import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Image,
  Card,
  Carousel,
  Container,
  Jumbotron,
  Row,
  Col,
} from "react-bootstrap";
import "./Maintenances.css";
import DataTableExtensions from "react-data-table-component-extensions";
import "react-data-table-component-extensions/dist/index.css";
import DataTable, { createTheme } from "react-data-table-component";
import { BsCamera } from "react-icons/bs";
import { confirmAlert } from "react-confirm-alert"; // Import
import "react-confirm-alert/src/react-confirm-alert.css"; // Import css

class HistoryEditor extends Component {
  constructor(props) {
    super(props);

    this.state = {
      task: this.props.report.task,
      id: this.props.report.id,
      notes: this.props.report.notes,
      employee: this.props.report.employee,
      createdAt: this.props.report.createdAt,
    };

    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  handleSubmit = (event) => {
    event.preventDefault();
    fetch("https://www.mantenimientoscvm.com/machines/editMaintenanceHistory", {
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
      });
  };

  delete = () => {
    confirmAlert({
      title: "Confirmar",
      message: "Seguro que quieres borrar esto? Esto es permanente.",
      buttons: [
        {
          label: "Yes",
          onClick: () =>
            fetch(
              "https://www.mantenimientoscvm.com/machines/deleteMaintenanceHistory",
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
    return this.state.task.length > 0;
  }

  render() {
    return (
      <div>
        <Card>
          <Card.Body>
            <form onSubmit={this.handleSubmit}>
              <FormGroup controlId="task">
                <FormLabel>Tarea Realizada:</FormLabel>
                <FormControl
                  autoFocus
                  disabled
                  type="type"
                  value={this.state.task}
                  onChange={this.handleChange}
                />
              </FormGroup>
              <FormGroup controlId="task">
                <FormLabel>Realizada Por:</FormLabel>
                <FormControl
                  autoFocus
                  disabled
                  type="type"
                  value={this.state.employee}
                  onChange={this.handleChange}
                />
              </FormGroup>

              <FormGroup controlId="task">
                <FormLabel>Notas:</FormLabel>
                <FormControl
                  autoFocus
                  disabled
                  type="type"
                  value={this.state.notes}
                  onChange={this.handleChange}
                />
              </FormGroup>
              <FormGroup controlId="task">
                <FormLabel>Fecha:</FormLabel>
                <FormControl
                  autoFocus
                  disabled
                  type="type"
                  value={this.state.createdAt}
                  onChange={this.handleChange}
                />
              </FormGroup>

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
      </div>
    );
  }
}
export default HistoryEditor;
