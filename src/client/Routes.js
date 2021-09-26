import React, { Component } from "react";
import Modal from "react-modal";
import { Container, Jumbotron, Row, Col, Button } from "react-bootstrap";

import Header from "./Components/Header/Header";
import { retrieveCookie } from "./Components/Cookies";
import MachineCard from "./Components/MachineCard/MachineCard";
import NewRoute from "./Components/Routes/NewRoute";
import "react-data-table-component-extensions/dist/index.css";
import DataTableExtensions from "react-data-table-component-extensions";
import DataTable, { createTheme } from "react-data-table-component";
import { BsThreeDotsVertical } from "react-icons/bs";

export default class Routes extends Component {
  constructor(props) {
    super(props);
    this.state = {
      routes: [],
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
    fetch(`http://192.168.1.153:4000/routes/getAll/`, {
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
        name: "Name",
        selector: "name",
        sortable: true,
      },
      {
        name: "Tasks Assigned",
        selector: "maintenanceTasks.length",
        sortable: true,
      },
      {
        name: "Employee",
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
        name: "Edit",
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
            pointerOnHover
            highlightOnHover
            pagination
            title="Routes"
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
                  New Route
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
                    X
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
