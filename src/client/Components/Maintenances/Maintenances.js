import React, { Component } from "react";
import Modal from "react-modal";
import { Container, Jumbotron, Row, Col, Button } from "react-bootstrap";
import DataTableExtensions from "react-data-table-component-extensions";

import ReportMaintenance from "../Report/ReportMaintenance";
import "react-data-table-component-extensions/dist/index.css";
import DataTable, { createTheme } from "react-data-table-component";

export default class Maintenances extends Component {
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
  }

  getMaintenanceReports() {
    fetch(`http://192.168.1.153:4000/routes/getAll/`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {});
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
        res.forEach((route) => {
          route.edit = (
            <Button onClick={() => this.handleOpenModal(route.id)}>Edit</Button>
          );
        });

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
    createTheme("machines", {
      text: {
        primary: "#00000",
        secondary: "#000000",
      },

      background: {
        default: "rgba(0,0,0,0)",
      },
      context: {
        background: "rgba(0,0,0,.2)",
        text: "#000000",
      },
      divider: {
        default: "rgba(0,0,0,.2)",
      },
      action: {
        button: "rgba(0,0,0,1)",
        hover: "rgba(0,0,0,.08)",
        disabled: "rgba(0,0,0,.12)",
      },
    });
    const columns = [
      {
        name: "Name",
        selector: "name",
        sortable: true,
      },
      {
        name: "Machines",
        selector: "vendingMachines.length",
        sortable: true,
      },
      {
        name: "Edit",
        selector: "edit",
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
            theme="machines"
            noHeader
            columns={columns}
            pagination
            subHeader
            subHeaderComponent={
              <Button onClick={() => this.handleOpenModal("new")}>
                New Route
              </Button>
            }
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
        </Modal>
      );
    });
    return modals;
  }

  render() {
    return (
      <div>
        <div className="body">
          <Modal
            shouldCloseOnOverlayClick
            isOpen={this.state.showModal === "new"}
          >
            <Button variant="outline-primary" onClick={this.handleCloseModal}>
              X
            </Button>
            <br />
            <br />
          </Modal>
          <Jumbotron>
            <h1>Maintenances</h1>
          </Jumbotron>
        </div>
      </div>
    );
  }
}
