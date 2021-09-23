import React, { Component } from "react";
import Modal from "react-modal";
import { Container, Jumbotron, Row, Col, Button } from "react-bootstrap";
import DataTableExtensions from "react-data-table-component-extensions";
import Header from "./Components/Header/Header";
import { retrieveCookie } from "./Components/Cookies";
import MachineCard from "./Components/MachineCard/MachineCard";
import NewRoute from "./Components/Routes/NewRoute";
import "react-data-table-component-extensions/dist/index.css";
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
    fetch(`http://localhost:4000/routes/getAll/`, {
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
            <BsThreeDotsVertical
              onClick={() => this.handleOpenModal(route.id)}
            />
          );
        });
        console.log(res);

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
        name: "Tasks Assigned",
        selector: "maintenanceTasks.length",
        sortable: true,
      },
      {
        name: "Employee",
        selector: (row) => {
          if (row.employees[0]) {
            return row.employees[0].name;
          }
        },
        sortable: true,
      },
      {
        name: "Edit",
        selector: "edit",
        sortable: false,
        right: true,
      },
    ];
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
            columns={columns}
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
