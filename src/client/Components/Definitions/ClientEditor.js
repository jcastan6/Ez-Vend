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
import { confirmAlert } from "react-confirm-alert"; // Import
import "react-confirm-alert/src/react-confirm-alert.css"; // Import css
import { BsFillXSquareFill, BsThreeDotsVertical } from "react-icons/bs";

class ClientEditor extends Component {
  constructor(props) {
    super(props);

    this.state = {
      id: this.props.client.id,
      name: this.props.client.name,
      showModal: false,
    };

    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  handleOpenModal() {
    this.setState({ showModal: true });
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }

  handleSubmit = (event) => {
    event.preventDefault();

    fetch("https://www.mantenimientoscvm.com//clients/editClient", {
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

  delete = () => {
    confirmAlert({
      title: "Confirmar",
      message: "Seguro que quieres borrar esto?",
      buttons: [
        {
          label: "Yes",
          onClick: () =>
            fetch("https://www.mantenimientoscvm.com//clients/deleteClient", {
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
              }),
        },
        {
          label: "No",
          onClick: () => console.log(),
        },
      ],
    });
  };

  validateForm() {
    return this.state.name.length > 0;
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
              <form onSubmit={this.handleSubmit} className="body">
                <FormGroup controlId="name">
                  <FormLabel>Nombre</FormLabel>
                  <FormControl
                    autoFocus
                    type="type"
                    value={this.state.name}
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
export default withRouter(ClientEditor);
