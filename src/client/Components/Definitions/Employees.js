import React, { Component } from "react";

import Modal from "react-modal";

import { Row, Col, Button, Card, Container } from "react-bootstrap";

import DataTable, { createTheme } from "react-data-table-component";

import DataTableExtensions from "react-data-table-component-extensions";
import "react-data-table-component-extensions/dist/index.css";

import { BsArrowLeft, BsThreeDotsVertical } from "react-icons/bs";
import NewEmployee from "./NewEmployee";
import EmployeeEditor from "./EmployeeEditor";

export default class Employees extends Component {
  constructor(props) {
    super(props);
    this.state = {
      employees: [],
      showModal: false,
    };

    this.getEmployees = this.getEmployees.bind(this);
    this.getEmployees();

    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
  }

  handleOpenModal(id) {
    this.setState({ showModal: id });
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }
  getEmployees() {
    fetch(`https://www.mantenimientoscvm.com/users/getEmployees`, {
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
            employees: res,
          },
          () => console.log()
        );
        this.handleCloseModal();
      });
  }

  renderEmployees() {
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
        style: {
          color: "#202124",
          fontSize: "14px",
          fontWeight: 500,
        },
      },
      {
        name: "Username",
        selector: "username",
        sortable: true,
      },
      {
        selector: "edit",
        cell: (row) => {
          return (
            <EmployeeEditor employee={row} getEmployees={this.getEmployees} />
          );
        },
        right: true,
        button: true,
      },
    ];

    return (
      <DataTableExtensions
        filterHidden={false}
        columns={columns}
        data={this.state.employees}
      >
        <DataTable
          title="Employees"
          data={this.state.employees}
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
                  Add Employee
                </Button>
              </Col>
              <br></br>
              <br></br>
              <Col>
                <Row className="table">{this.renderEmployees()}</Row>
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
                <NewEmployee getEmployees={this.getEmployees}></NewEmployee>
              </Card.Body>
            </Card>
          </Modal>
        </div>
      </div>
    );
  }
}
