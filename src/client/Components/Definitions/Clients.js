import React, { Component } from "react";

import Modal from "react-modal";

import { Row, Col, Button, Card, Container } from "react-bootstrap";

import DataTable, { createTheme } from "react-data-table-component";

import DataTableExtensions from "react-data-table-component-extensions";
import "react-data-table-component-extensions/dist/index.css";

import { BsArrowLeft, BsThreeDotsVertical } from "react-icons/bs";

import NewClient from "./NewClient";
import ClientEditor from "./ClientEditor";
export default class Clients extends Component {
  constructor(props) {
    super(props);
    this.state = {
      clients: [],
      showModal: false,
    };

    this.getClients = this.getClients.bind(this);
    this.getClients();

    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
  }

  handleOpenModal(id) {
    this.setState({ showModal: id });
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }
  getClients() {
    fetch(`https://www.mantenimientoscvm.com/clients/getAll`, {
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
        this.handleCloseModal();
      });
  }

  renderClients() {
    const customStyles = {
      context: {
        background: "#cb4b16",
        text: "#FFFFFF",
      },
      headCells: {
        style: {
          fontSize: "14px",
        },
      },
      rows: {
        highlightOnHoverStyle: {
          backgroundColor: "rgb(230, 244, 244)",
          borderBottomColor: "#FFFFFF",
          outline: "1px solid #FFFFFF",
        },
      },
      pagination: {
        style: {
          border: "none",
        },
      },
    };
    const columns = [
      {
        name: "Nombre",
        selector: "name",
        sortable: true,
        style: {
          color: "#202124",
          fontSize: "14px",
          fontWeight: 500,
        },
      },
      {
        name: "Cuenta de Maquinas",
        selector: "count",
        sortable: true,
      },
      {
        name: "Editar Cliente",
        selector: "edit",
        cell: (row) => {
          return <ClientEditor client={row} getClients={this.getClients} />;
        },
        cellExport: (row) => {
          return "";
        },
        right: true,
        button: true,
      },
    ];

    return (
      <DataTableExtensions
        filterHidden={false}
        columns={columns}
        data={this.state.clients}
      >
        <DataTable
          title="Clientes"
          data={this.state.clients}
          customStyles={customStyles}
          columns={columns}
          pagination
          noheader
          pointerOnHover
          highlightOnHover
        />
      </DataTableExtensions>
    );
  }

  render() {
    return (
      <div>
        <div className="">
          <Container fluid>
            <Row>
              <Col lg={2}>
                <Button onClick={() => this.handleOpenModal("new")}>
                  Agregar Cliente
                </Button>
              </Col>
              <br></br>
              <br></br>
              <Col>
                <Row className="table">{this.renderClients()}</Row>
              </Col>
            </Row>
          </Container>

          <Modal
            shouldCloseOnOverlayClick={true}
            onRequestClose={this.handleCloseModal}
            isOpen={this.state.showModal === "new"}
            className="modal-form"
          >
            <Card>
              <Card.Body>
                <NewClient getClients={this.getClients}></NewClient>
              </Card.Body>
            </Card>
          </Modal>
        </div>
      </div>
    );
  }
}
