import React, { Component } from "react";
import { PullToRefresh } from "react-js-pull-to-refresh";
import Sidebar from "react-sidebar";
import "react-data-table-component-extensions/dist/index.css";
import DataTableExtensions from "react-data-table-component-extensions";
import DataTable, { createTheme } from "react-data-table-component";
import {
  PullDownContent,
  ReleaseContent,
  RefreshContent,
} from "react-js-pull-to-refresh";
import "./employeeView.css";

import {
  Button,
  Row,
  Col,
  Container,
  Jumbotron,
  Form,
  FormGroup,
  FormControl,
  FormLabel,
  Card,
} from "react-bootstrap";
import "./employeeView.css";
import SubmitTask from "./SubmitTask";
import { retrieveCookie, saveCookie } from "./employeeCookie";

export default class EmployeeView extends Component {
  constructor(props) {
    super(props);
    this.state = {
      employeeId: retrieveCookie().user || "",
      routeTasks: [],
      sidebarOpen: false,
      refreshingContent: false,
      pass: "",
      username: "",
      secret: retrieveCookie().secret || false,
    };
    this.getRoute = this.getRoute.bind(this);
    this.renderTasks = this.renderTasks.bind(this);
    this.setSidebarClose = this.setSidebarClose.bind(this);
    this.setSidebarOpen = this.setSidebarOpen.bind(this);
    this.onRefresh = this.onRefresh.bind(this);
    this.checkPass = this.checkPass.bind(this);
    this.getRoute();
  }

  checkPass = (event) => {
    event.preventDefault();
    fetch(`http://54.177.22.144:3001/users/employeeLogin/`, {
      method: "POST",
      body: JSON.stringify({
        secret: this.state.pass,
        username: this.state.username,
      }),
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((res) => res.json())
      .then((res) => {
        if (res.status === 200) {
          saveCookie(true, res.user.id);
          this.setState({
            employeeId: res.user.id,
            secret: true,
          }),
            () => console.log();
          this.getRoute();
        } else {
        }
      });
  };
  getRoute() {
    fetch(
      `http://54.177.22.144:3001/users/getEmployeeRoute/${this.state.employeeId}`,
      {
        method: "GET",
        credentials: "same-origin",
        headers: {
          "Content-Type": "application/json",
        },
      }
    )
      .then((response) => response.json())
      .then((res) => {
        let tasks = res.maintenanceTasks;
        tasks.sort((a, b) =>
          a.employeeTasks.priority > b.employeeTasks.priority ? 1 : -1
        );

        this.setState(
          {
            routes: res,
            refreshingContent: false,
            routeTasks: tasks,
          },
          () => console.log()
        );
      });
  }
  setSidebarOpen(open) {
    window.scrollTo(0, 0);
    let task = this.state.routeTasks.at(open);
    let content = (
      <div className="body">
        <br></br>
        <Container fluid>
          <SubmitTask task={task} employee={this.state.employeeId}></SubmitTask>
        </Container>
      </div>
    );
    this.setState({ sidebarOpen: open, sidebar: content });
  }

  setSidebarClose() {
    this.setState({ sidebarOpen: false, sidebar: null });
  }

  renderTasks() {
    if (this.state.routeTasks.length > 0) {
      let cards = [];

      for (let index = 0; index < this.state.routeTasks.length; index++) {
        cards.push(
          <div>
            <br />

            <a onClick={() => this.setSidebarOpen(index)}>
              <Card
                body
                className={
                  this.state.routeTasks[index].emergency === true
                    ? "emergency-task table task-card"
                    : "table task-card "
                }
              >
                <Row>
                  <Col className="index-col" xs={3}>
                    <h1>{index + 1}</h1>
                  </Col>
                  <Col>
                    <Card.Title>
                      <p>
                        Maquina:{" "}
                        {this.state.routeTasks[index].vendingMachine.machineNo}
                      </p>
                      <p>
                        Cliente:{" "}
                        {
                          this.state.routeTasks[index].vendingMachine.client
                            .name
                        }
                      </p>
                      <p>Mantenimiento: {this.state.routeTasks[index].task}</p>
                    </Card.Title>
                  </Col>
                </Row>
              </Card>
            </a>
          </div>
        );
      }

      return cards;
    }
  }
  onRefresh() {
    return new Promise((resolve) => {
      setTimeout(resolve, 500);
      this.getRoute();
    });
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  render() {
    if (this.state.secret === false) {
      return (
        <div className="body-mobile">
          <form onSubmit={this.checkPass}>
            <FormGroup className="userId" controlId="username">
              <FormLabel>Username</FormLabel>
              <FormControl
                type="input-"
                size="lg"
                value={this.state.username}
                onChange={this.handleChange}
              ></FormControl>
            </FormGroup>
            <FormGroup className="userId" controlId="pass">
              <FormLabel>Password</FormLabel>
              <FormControl
                type="password"
                size="lg"
                value={this.state.pass}
                onChange={this.handleChange}
              ></FormControl>
            </FormGroup>
            <Button block type="submit" onClick={this.onSubmit}>
              Login
            </Button>
          </form>
        </div>
      );
    }
    return (
      <div className="body">
        <Container className="body">
          <Sidebar
            touch
            pullRight
            sidebar={this.state.sidebar}
            open={this.state.sidebarOpen !== false}
            onSetOpen={() => this.setSidebarClose()}
            styles={{
              sidebar: {
                background: "white",
                width: "100%",
              },
            }}
          />{" "}
          <br></br>
          <Card body className="table task-card">
            <Card.Title>Open Tasks</Card.Title>
          </Card>
          {this.renderTasks()}
        </Container>
      </div>
    );
  }
}
