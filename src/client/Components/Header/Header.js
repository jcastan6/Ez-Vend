import React, { Component } from "react";
import {
  Navbar,
  Nav,
  NavDropdown,
  Form,
  FormControl,
  Button,
  FormGroup,
} from "react-bootstrap";
import "./Header.css";
import { withRouter } from "react-router";
import { retrieveCookie, deleteCookie } from "../Cookies";

class Header extends Component {
  constructor(props) {
    super(props);
    console.log(props);
    this.state = {
      username: retrieveCookie(),
    };

    if (!this.state.username) {
      alert("Not logged in.");
      this.props.history.push("/");
    }
  }

  render() {
    const { location } = this.props;
    return (
      <Navbar className="navbar" expand="lg">
        <Navbar.Brand>
          <img
            src="https://00f74ba44b70baeb6018bccc0ce90629f7e1f5f865-apidata.googleusercontent.com/download/storage/v1/b/ezvend/o/cvm.png?jk=AFshE3WXVN609aUgr9nGTV2W-UY4Whr7F7eFnTH2sYBQW_JxC2VWQJhq2KYk0dXYd10L326WhvnwhC5sKej-FrIQ7-wdCuQzCv4mOLLa3sduJazK5rsFwLjQNKqVTiRCJqj6cC8NDPOtRc0sglBe_5wJHVSRB59wwbFht4zUHuJ3cViPFomf_5PRnMvtRMBmXKVAm6aeOKgjBnPBAp_5MxOrIya9ZI9aCMU--h5POuT9Z2nJQY-6vYSixD6y-4HmNrafeCGP37mqyH3Q_iNqxxLZ043WxLUhUrm0PQAQxgWQbxsx3ZMvSadPPy7jSQgW05HUZPWQMmhC7E7-xemCJa_D1BwsW_JsYZfsiINQhlGNQAJhQZLkccqBWqHD8KzejHh-ofmOtwqD6MUXoORU6RfVX3N_77kepudQN1gmI_gv8GRnWgePdru0LcUbcwJW9Xjh40Yb91uqYzq-7DtmUnGhb6VADOmLoOc9JONIkhTV9Jazy_T_WpQRT-3C0tbzt3S2QeR2tte04ygYFEcAC40HSZ9NB_iL1GPVDgvx76JGyQC_WJSFHkm_VZUb6IaD39OjQi1yH1G2EsReHmoolXlaXDWMHwtF35tYs2a6N-s5kxA9TlrhxhBoPzUvUTTHQoziQ9c9876vcHGFurKKOww-xCTugesmITNeiY1TbdE82t00UdawFlLNhZzN_vQC9vfh8GrWe8mgaVgTi-9Teyo9nNmk4O8Nvwt4T4bQ2icyN9SyKCiYH0IvZp46d9QoefBSk_0nLIVUnW8UESQK24xSSmhKwdUVPuVsG6UxTTbQ7S3t9iN2fSjsDHSnyXcG_kXwU21Lzv-7d2uI2sOpwx1Tb1KPxOt1-FHvIggkykJ72Aw5tr6-hlKYZKzPUvCJD2QzIYy6QCe-zQzgNWC__9aw3JH6C-ufi1qISAEkvfAa7Fpsz09Q&isca=1"
            width="100"
            className="d-inline-block align-top"
            alt="CVM"
          />
        </Navbar.Brand>
        <Navbar.Toggle aria-controls="basic-navbar-nav" />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav className="mr-auto" activeKey={location.pathname}>
            <Nav.Link href="/Home">Home</Nav.Link>
            <Nav.Link href="/Routes">Routes</Nav.Link>
            <Nav.Link href="/Machines">Machines</Nav.Link>
            <Nav.Link href="/Definitions">Definitions</Nav.Link>
          </Nav>
        </Navbar.Collapse>
      </Navbar>
    );
  }
}

export default withRouter(Header);
