import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Card,
  Form,
} from "react-bootstrap";

import Modal from "react-modal";
import { BsFillXSquareFill, BsThreeDotsVertical } from "react-icons/bs";
import { confirmAlert } from "react-confirm-alert"; // Import
import "react-confirm-alert/src/react-confirm-alert.css"; // Import css

class EmployeeEditor extends Component {
  constructor(props) {
    super(props);
    this.toggleTechnician = this.toggleTechnician.bind(this);
    this.getTypes = this.getTypes.bind(this);
    this.state = {
      id: this.props.employee.id,
      name: this.props.employee.name,
      type: this.props.employee.type,
      username: this.props.employee.username,
      isTechnician: this.props.employee.isTechnician,
    };
    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
    if (this.state.isTechnician) {
      this.getTypes();
    }
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  handleSubmit = (event) => {
    event.preventDefault();

    fetch("https://www.mantenimientoscvm.com/users/editEmployee", {
      method: "POST",
      credentials: "same-origin",
      body: JSON.stringify(this.state),
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((res) => res.json())
      .then((res) => {
        this.props.getClients();
      });
  };
  handleOpenModal() {
    this.setState({ showModal: true });
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }

  delete = () => {
    confirmAlert({
      title: "Confirmar",
      message: "Seguro que quieres borrar esto?",
      buttons: [
        {
          label: "Yes",
          onClick: () =>
            fetch("https://www.mantenimientoscvm.com/users/deleteEmployee", {
              method: "POST",
              credentials: "same-origin",
              body: JSON.stringify(this.state),
              headers: {
                "Content-Type": "application/json",
              },
            })
              .then((res) => res.json())
              .then((res) => {
                this.props.getEmployees();
              }),
        },
        {
          label: "No",
          onClick: () => console.log,
        },
      ],
    });
  };
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
          this.props.refresh();
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
    this.setState({
      isTechnician: !this.state.isTechnician,
    });
  }

  validateForm() {
    return this.state.name.length > 0;
  }

  render() {
    return (
      <div className="">
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
                <b>Editar Información de Empleado</b>
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
export default withRouter(EmployeeEditor);
