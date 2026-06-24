# EKS Module

Creates the Kubernetes control plane, worker nodes, AWS-managed cluster
add-ons, IAM roles, and shared storage support used by the application
manifests.

## Resources

- `aws_iam_role.cluster`: EKS control plane role.
- `aws_iam_role_policy_attachment.cluster_policy`: attaches `AmazonEKSClusterPolicy`.
- `aws_iam_role.node`: managed node group role.
- `aws_iam_role_policy_attachment.node_worker`: attaches worker, CNI, ECR read,
  and SSM managed policies.
- `aws_security_group.cluster`: control plane security group.
- `aws_security_group.node`: legacy worker security group retained for existing
  stacks; current managed nodes use the EKS-created cluster security group.
- `aws_eks_cluster.main`: EKS cluster in private subnets.
- `tls_certificate.eks`: reads the cluster OIDC issuer certificate.
- `aws_iam_openid_connect_provider.eks`: OIDC provider for IRSA.
- `aws_eks_node_group.main`: managed worker node group.
- `aws_eks_node_group.llm`: optional dedicated managed node group labeled and
  tainted for the self-hosted LLM workload.
- `aws_eks_addon.coredns`: CoreDNS add-on.
- `aws_eks_addon.kube_proxy`: kube-proxy add-on.
- `aws_eks_addon.vpc_cni`: VPC CNI add-on.
- `aws_iam_role.ebs_csi`: IRSA role for the EBS CSI controller.
- `aws_iam_role_policy_attachment.ebs_csi`: attaches `AmazonEBSCSIDriverPolicy`.
- `aws_eks_addon.ebs_csi`: EBS CSI add-on using the controller IRSA role.
- `aws_efs_file_system.reports`: encrypted EFS file system for generated reports.
- `aws_security_group.efs`: allows NFS from the EKS managed node security group.
- `aws_efs_mount_target.reports`: EFS mount target in each private subnet.
- `aws_iam_policy.efs_csi`: EFS CSI permissions.
- `aws_iam_role.efs_csi`: IRSA role for the EFS CSI controller.
- `aws_iam_role_policy_attachment.efs_csi`: attaches EFS CSI permissions.
- `aws_iam_role.albc`: IRSA role for AWS Load Balancer Controller.
- `aws_iam_policy.albc`: ALB controller IAM policy from `albc-iam-policy.json`.
- `aws_iam_role_policy_attachment.albc`: attaches ALB controller policy.

The AWS EFS CSI driver, AWS Load Balancer Controller, External Secrets
Operator, and `efs-sc` StorageClass are installed with Helm from the
`helm-charts` repository by `investments-assistant-k8s`.

## Inputs

| Name | Type | Required | Description |
| --- | --- | --- | --- |
| `cluster_name` | `string` | Yes | EKS cluster name and resource prefix. |
| `k8s_version` | `string` | Yes | Kubernetes version for the EKS control plane. The desired project target is `1.33`; use interim versions only for one-minor-at-a-time in-place upgrades. |
| `vpc_id` | `string` | Yes | VPC where cluster security groups are created. |
| `private_subnet_ids` | `list(string)` | Yes | Private subnets for the cluster, node group, and EFS mount targets. |
| `node_instance_type` | `string` | Yes | EC2 instance type for managed worker nodes. |
| `node_min_size` | `number` | Yes | Minimum node group size. |
| `node_max_size` | `number` | Yes | Maximum node group size. |
| `node_desired_size` | `number` | Yes | Desired node group size. |
| `enable_llm_node_group` | `bool` | Yes | Whether to create the dedicated LLM node group. |
| `llm_node_instance_type` | `string` | Yes | EC2 instance type for the dedicated LLM node group. |
| `llm_node_min_size` | `number` | Yes | Minimum LLM node group size. |
| `llm_node_max_size` | `number` | Yes | Maximum LLM node group size. |
| `llm_node_desired_size` | `number` | Yes | Desired LLM node group size. |
| `aws_region` | `string` | No | Deprecated compatibility input. Helm-managed add-ons receive the region from the deployment command. |

## Outputs

| Name | Description |
| --- | --- |
| `cluster_name` | EKS cluster name. |
| `cluster_endpoint` | Kubernetes API endpoint. |
| `cluster_certificate_authority_data` | Base64 cluster CA data. |
| `node_security_group_id` | EKS managed node security group ID used by RDS, Redis, and EFS ingress rules. |
| `oidc_provider_arn` | OIDC provider ARN used by IRSA roles. |
| `oidc_provider_url` | OIDC provider URL used by IRSA trust conditions. |
| `efs_id` | EFS file system ID for report storage. |
| `efs_csi_role_arn` | IRSA role ARN used by the AWS EFS CSI driver Helm chart. |
| `aws_load_balancer_controller_role_arn` | IRSA role ARN used by the AWS Load Balancer Controller Helm chart. |

## Used By

The root stack uses the node security group output for RDS and Redis ingress.
The secrets module uses the OIDC outputs to create IRSA roles. The Kubernetes
deployment uses the EFS ID and controller role outputs when installing Helm
charts from the `helm-charts` repository.

The LLM node group is enabled by default because the Ollama deployment requests
more memory than the default `t3.medium` workers can provide. It is labeled
`workload=llm` and tainted with `workload=llm:NoSchedule`; the `k8s/llm`
deployment selects and tolerates that node group.
