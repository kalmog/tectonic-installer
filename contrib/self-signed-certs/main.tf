module "ca" {
  source = "./ca/self-signed"

  root_ca_cert_pem = "${module.ca_certs.kube_ca_cert_pem}"
  root_ca_key_alg  = "${var.tectonic_ca_key_alg}"
  root_ca_key_pem  = "${var.tectonic_ca_key}"
}

module "kube_certs" {
  source = "./kube/self-signed"

  kube_apiserver_url = "https://${var.api_fqdn}:443"
  service_cidr       = "${var.service_cidr}"
}

module "etcd_certs" {
  source = "./etcd/self-signed"

  etcd_cert_dns_names = "${var.etcd_dns_names}"
  service_cidr        = "${var.service_cidr}"
}

module "ingress_certs" {
  source = "./ingress/self-signed"

  base_address = "${var.console_fqdn}"
  ca_cert_pem  = "${module.kube_certs.ca_cert_pem}"
  ca_key_alg   = "${module.kube_certs.ca_key_alg}"
  ca_key_pem   = "${module.kube_certs.ca_key_pem}"
}

module "identity_certs" {
  source = "./identity/self-signed"

  ca_cert_pem = "${module.kube_certs.ca_cert_pem}"
  ca_key_alg  = "${module.kube_certs.ca_key_alg}"
  ca_key_pem  = "${module.kube_certs.ca_key_pem}"
}
