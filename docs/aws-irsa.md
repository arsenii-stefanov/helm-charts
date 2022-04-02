## AWS-IRSA Helm Chart

This Helm chart is to be used with the ACK IAM Controller that uses CustomResourceDefinitions called Roles and Policies for creating AWS IAM roles and IAM policies right from your EKS cluster

Reference: https://github.com/aws-controllers-k8s/iam-controller

### Example. Install a Helm chart for `cert-manager` in EKS and create an IAM role for the `cert-manager` K8s ServiceAccount

* Create a Helm chart

```
apiVersion: v2
name: cert-manager
description: A Helm chart for cert-manager
type: application
version: 1.7.2
dependencies:
  - name: "cert-manager"
    version: "v1.7.2"
    repository: "https://charts.jetstack.io"
  - name: "aws-irsa"
    version: "0.0.1"
    repository: "https://arsenii-stefanov.github.io/helm-charts/"
```

* Create a `values.yaml` file

```
cert-manager:
  serviceAccount:
    ### Instruct the 'cert-manager' chart not to create a ServiceAccount, the 'aws-irsa' chart will create it instead
    create: false
    ### The name of the ServiceAccount 'cert-manager' is expecting to have should match the name of
    ### the ServiceAccount 'aws-irsa' will create - '.aws-irsa.irsa[0].serviceAccountName'
    name: cert-manager
    ### Other config options for cert-manager go below
    <...>
    <...>

aws-irsa:
  awsAccountID: "123456789012"
  clusterName: webapp-test-cluster-us-east-1
  oidc: oidc.eks.us-east-1.amazonaws.com/id/FA8FZD22483883CDB3A8T53BB269E428
  irsa:
    - name: cert-manager
      serviceAccountName: cert-manager
      maxSessionDuration: 43200
      policies:
        - name: "main-policy"
          policyDocumentYAML:
            Version: "2012-10-17"
            Statement:
              - Sid: "GetChange"
                Effect: "Allow"
                Action: "route53:GetChange"
                Resource: "arn:aws:route53:::change/*"
              - Sid: "EditZoneRecords"
                Effect: "Allow"
                Action:
                  - "route53:ListResourceRecordSets"
                  - "route53:ChangeResourceRecordSets"
                Resource:
                  - "arn:aws:route53:::hostedzone/Z04611152TQ4DODJQOWZ2"
              - Sid: "ListZones"
                Effect: "Allow"
                Action: "route53:ListHostedZonesByName"
                Resource: ["*"]
        ### If you hit the IAM policy character limit (6,144), you may want to split your policy in 2 (or more) policies
        - name: "aux-policy"
          policyDocumentYAML:
            Version: "2012-10-17"
            Statement:
              - Sid: "GetChange"
                Effect: "Allow"
                Action: "<some action>"
                Resource: "<some resource>"
```
