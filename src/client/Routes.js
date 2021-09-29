import React, { Component } from "react";
import Modal from "react-modal";
import { Container, Row, Col, Button } from "react-bootstrap";

import Header from "./Components/Header/Header";

import NewRoute from "./Components/Routes/NewRoute";
import "react-data-table-component-extensions/dist/index.css";
import DataTableExtensions from "react-data-table-component-extensions";
import DataTable, { createTheme } from "react-data-table-component";
import { BsThreeDotsVertical } from "react-icons/bs";

import styled, { keyframes } from "styled-components";
const rotate360 = keyframes`
  from {
    transform: rotate(0deg);
  }

  to {
    transform: rotate(360deg);
  }
`;

const Spinner = styled.div`
  margin: 16px;
  animation: ${rotate360} 1s linear infinite;
  transform: translateZ(0);
  border-top: 2px solid grey;
  border-right: 2px solid grey;
  border-bottom: 2px solid grey;
  border-left: 4px solid black;
  background: transparent;
  width: 80px;
  height: 80px;
  border-radius: 50%;
`;

const CustomLoader = () => (
  <div style={{ padding: "24px" }}>
    <Spinner />
    <div>Cargando...</div>
  </div>
);

export default class Routes extends Component {
  constructor(props) {
    super(props);
    this.state = {
      routes: [],
      routesPending: true,
    };
    this.renderRoutes = this.renderRoutes.bind(this);
    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
    this.getRoutes = this.getRoutes.bind(this);
    this.getRoutes();
  }

  handleOpenModal(id) {
    this.setState({ showModal: id });
  }

  handleCloseModal() {
    this.setState({ showModal: false });
    this.getRoutes();
  }

  getRoutes() {
    this.setState({
      routesPending: true,
    });
    fetch(`https://www.mantenimientoscvm.com//routes/getAll/`, {
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
            routes: res,
            showModal: false,
            routesPending: false,
          },
          () => console.log()
        );
      });
  }

  renderRoutes() {
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
      },
      {
        name: "Tareas Asignadas",
        selector: "maintenanceTasks.length",
        sortable: true,
      },
      {
        name: "Empleado",
        cell: (row) => {
          if (row.employees) {
            let name = [];
            row.employees.forEach((e) => {
              name.push(e.name + " ");
            });
            return name;
          }
        },
        sortable: true,
      },
      {
        name: "Editar Ruta",
        cell: (row) => (
          <BsThreeDotsVertical onClick={() => this.handleOpenModal(row.id)} />
        ),
        sortable: false,
        right: true,
      },
    ];

    return (
      <div className="table">
        <DataTableExtensions
          filterHidden={false}
          columns={columns}
          data={this.state.routes}
        >
          <DataTable
            data={this.state.routes}
            customStyles={customStyles}
            noHeader
            onRowDoubleClicked={(row) => {
              this.handleOpenModal(row.id);
            }}
            columns={columns}
            progressPending={this.state.routesPending}
            progressComponent={<CustomLoader />}
            pointerOnHover
            highlightOnHover
            pagination
            title="Rutas"
          />
        </DataTableExtensions>
      </div>
    );
  }

  renderRouteModals() {
    let modals = [];
    this.state.routes.forEach((route) => {
      modals.push(
        <Modal
          shouldCloseOnOverlayClick
          isOpen={this.state.showModal === route.id}
        >
          <Button variant="outline-primary" onClick={this.handleCloseModal}>
            X
          </Button>
          <br />
          <br />
          <NewRoute getRoutes={this.getRoutes} route={route} />
        </Modal>
      );
    });
    return modals;
  }

  render() {
    return (
      <div>
        <Header></Header>
        <div className="body">
          <Container fluid>
            <Row>
              <Col lg={2}>
                <Button onClick={() => this.handleOpenModal("new")}>
                  Crear Ruta
                </Button>
              </Col>
              <br />
              <br />
              <Col>
                <Modal
                  shouldCloseOnOverlayClick
                  isOpen={this.state.showModal === "new"}
                >
                  <Button
                    variant="outline-primary"
                    onClick={this.handleCloseModal}
                  >
                    Cerrar
                  </Button>
                  <br />
                  <br />
                  <NewRoute getRoutes={this.getRoutes} />
                </Modal>

                {this.renderRoutes()}
                {this.renderRouteModals()}
              </Col>
            </Row>
          </Container>
        </div>
      </div>
    );
  }
}
